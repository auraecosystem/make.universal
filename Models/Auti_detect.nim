# ============================================================
# File: Auto-detect.nim
# Description:
#   Advanced system/environment auto-detection module for Nim.
#
# Features:
#   - OS detection
#   - CPU architecture detection
#   - Shell detection
#   - Runtime detection
#   - Package manager detection
#   - Container / VM detection
#   - Network interface scan
#   - Language/toolchain discovery
#   - JSON export
#
# Author: RODA AI
# ============================================================

import os
import osproc
import strutils
import json
import sequtils
import tables
import net

# ============================================================
# TYPES
# ============================================================

type
  DetectInfo* = object
    hostname*: string
    osName*: string
    osVersion*: string
    architecture*: string
    shell*: string
    currentUser*: string
    isAdmin*: bool
    isContainer*: bool
    isVirtualMachine*: bool
    packageManagers*: seq[string]
    runtimes*: seq[string]
    languages*: seq[string]
    ipAddresses*: seq[string]
    environment*: Table[string, string]

# ============================================================
# UTILS
# ============================================================

proc safeExec(cmd: string): string =
  try:
    result = execProcess(cmd).strip()
  except:
    result = ""

proc commandExists(cmd: string): bool =
  when defined(windows):
    result = safeExec("where " & cmd).len > 0
  else:
    result = safeExec("which " & cmd).len > 0

proc addIfExists(list: var seq[string], cmd: string) =
  if commandExists(cmd):
    list.add(cmd)

# ============================================================
# OS DETECTION
# ============================================================

proc detectOS*(): tuple[name, version: string] =
  when defined(windows):
    result.name = "Windows"
    result.version = safeExec("ver")

  elif defined(macosx):
    result.name = "macOS"
    result.version = safeExec("sw_vers -productVersion")

  elif defined(linux):
    result.name = "Linux"

    if fileExists("/etc/os-release"):
      let data = readFile("/etc/os-release")

      for line in data.splitLines:
        if line.startsWith("PRETTY_NAME="):
          result.version = line.split("=")[1]
            .replace("\"", "")
            .strip()

    if result.version.len == 0:
      result.version = safeExec("uname -r")

  else:
    result.name = "Unknown"
    result.version = "Unknown"

# ============================================================
# ARCH DETECTION
# ============================================================

proc detectArch*(): string =
  when defined(amd64):
    result = "x86_64"

  elif defined(i386):
    result = "x86"

  elif defined(arm64):
    result = "ARM64"

  elif defined(arm):
    result = "ARM"

  else:
    result = hostCPU

# ============================================================
# SHELL DETECTION
# ============================================================

proc detectShell*(): string =
  when defined(windows):
    result = getEnv("COMSPEC")
  else:
    result = getEnv("SHELL")

# ============================================================
# ADMIN / ROOT DETECTION
# ============================================================

proc detectAdmin*(): bool =
  when defined(windows):
    let outp = safeExec("net session")
    result = not outp.contains("Access is denied")
  else:
    result = getEnv("USER") == "root"

# ============================================================
# CONTAINER DETECTION
# ============================================================

proc detectContainer*(): bool =
  when defined(linux):
    if fileExists("/.dockerenv"):
      return true

    if fileExists("/proc/1/cgroup"):
      let cg = readFile("/proc/1/cgroup")
      if cg.contains("docker") or
         cg.contains("kubepods") or
         cg.contains("containerd"):
        return true

  return false

# ============================================================
# VM DETECTION
# ============================================================

proc detectVM*(): bool =
  when defined(windows):
    let info = safeExec("wmic computersystem get model")
    result =
      info.contains("Virtual") or
      info.contains("VMware") or
      info.contains("VirtualBox")

  elif defined(linux):
    let info = safeExec("systemd-detect-virt")
    result = info.len > 0

  else:
    result = false

# ============================================================
# PACKAGE MANAGER DETECTION
# ============================================================

proc detectPackageManagers*(): seq[string] =
  var managers: seq[string] = @[]

  let known = @[
    "apt",
    "dnf",
    "yum",
    "pacman",
    "zypper",
    "apk",
    "brew",
    "choco",
    "winget",
    "snap",
    "flatpak",
    "npm",
    "yarn",
    "pnpm",
    "pip",
    "cargo",
    "go"
  ]

  for pm in known:
    managers.addIfExists(pm)

  result = managers

# ============================================================
# LANGUAGE / TOOLCHAIN DETECTION
# ============================================================

proc detectLanguages*(): seq[string] =
  var langs: seq[string] = @[]

  let tools = @[
    "nim",
    "python",
    "node",
    "ruby",
    "perl",
    "php",
    "java",
    "go",
    "rustc",
    "cargo",
    "gcc",
    "clang",
    "dotnet",
    "swift",
    "deno"
  ]

  for tool in tools:
    langs.addIfExists(tool)

  result = langs

# ============================================================
# RUNTIME DETECTION
# ============================================================

proc detectRuntimes*(): seq[string] =
  var rt: seq[string] = @[]

  let runtimes = @[
    "docker",
    "podman",
    "kubectl",
    "node",
    "bun",
    "python",
    "java",
    "dotnet"
  ]

  for r in runtimes:
    rt.addIfExists(r)

  result = rt

# ============================================================
# IP ADDRESS DETECTION
# ============================================================

proc detectIPs*(): seq[string] =
  var ips: seq[string] = @[]

  try:
    let hostname = getHostname()
    let addresses = getHostByName(hostname)

    for addr in addresses.addrList:
      ips.add($addr)
  except:
    discard

  result = ips.deduplicate()

# ============================================================
# ENVIRONMENT SNAPSHOT
# ============================================================

proc captureEnvironment*(): Table[string, string] =
  var envTable = initTable[string, string]()

  for key, value in envPairs():
    envTable[key] = value

  result = envTable

# ============================================================
# MAIN DETECTOR
# ============================================================

proc autoDetect*(): DetectInfo =
  let osInfo = detectOS()

  result.hostname = getHostname()
  result.osName = osInfo.name
  result.osVersion = osInfo.version
  result.architecture = detectArch()
  result.shell = detectShell()
  result.currentUser = getEnv("USER", getEnv("USERNAME"))
  result.isAdmin = detectAdmin()
  result.isContainer = detectContainer()
  result.isVirtualMachine = detectVM()
  result.packageManagers = detectPackageManagers()
  result.runtimes = detectRuntimes()
  result.languages = detectLanguages()
  result.ipAddresses = detectIPs()
  result.environment = captureEnvironment()

# ============================================================
# JSON EXPORT
# ============================================================

proc toJson*(info: DetectInfo): JsonNode =
  result = %*{
    "hostname": info.hostname,
    "os_name": info.osName,
    "os_version": info.osVersion,
    "architecture": info.architecture,
    "shell": info.shell,
    "current_user": info.currentUser,
    "is_admin": info.isAdmin,
    "is_container": info.isContainer,
    "is_virtual_machine": info.isVirtualMachine,
    "package_managers": info.packageManagers,
    "runtimes": info.runtimes,
    "languages": info.languages,
    "ip_addresses": info.ipAddresses,
    "environment": info.environment
  }

# ============================================================
# PRETTY PRINT
# ============================================================

proc prettyPrint*(info: DetectInfo) =
  echo "=================================================="
  echo " AUTO-DETECT REPORT"
  echo "=================================================="

  echo "Hostname           : ", info.hostname
  echo "OS                 : ", info.osName
  echo "OS Version         : ", info.osVersion
  echo "Architecture       : ", info.architecture
  echo "Shell              : ", info.shell
  echo "User               : ", info.currentUser
  echo "Admin              : ", info.isAdmin
  echo "Container          : ", info.isContainer
  echo "Virtual Machine    : ", info.isVirtualMachine

  echo "\nPackage Managers:"
  for pm in info.packageManagers:
    echo "  - ", pm

  echo "\nLanguages:"
  for lang in info.languages:
    echo "  - ", lang

  echo "\nRuntimes:"
  for rt in info.runtimes:
    echo "  - ", rt

  echo "\nIP Addresses:"
  for ip in info.ipAddresses:
    echo "  - ", ip

# ============================================================
# ENTRY POINT
# ============================================================

when isMainModule:
  let info = autoDetect()

  prettyPrint(info)

  echo "\n=================================================="
  echo " JSON OUTPUT"
  echo "=================================================="

  echo pretty(toJson(info))
