# Security Architecture

The security subsystem is deliberately data-first. Advisories are normalized into `advisories/`, OSV-compatible records into `osv/`, SARIF findings into `sarif/`, and CVE records into `cve/`. Generated evidence lives below `security/` so build outputs and security evidence can be packaged together.

## Pipeline

`scan -> ingest -> normalize -> score -> prioritize -> sbom -> provenance -> sign -> verify -> report`

The checked-in indexes are deterministic catalogs. Network ingestion is optional and must never overwrite source records without preserving the upstream identifier and retrieval timestamp.

## Policy model

`build.mu` declares security gates for scan, CVE, OSV, SBOM, SARIF, secrets, and licenses, with `critical` as the default failure threshold. Release configuration requests signing, provenance, SHA-256/SHA-512 checksums, and publishing.

## Trust boundaries

External advisory feeds are untrusted input. Parsers validate schemas, reject malformed identifiers, normalize versions, and preserve source URLs. Signing keys never belong in the repository. CI should use short-lived Sigstore/OIDC credentials where supported.

## Severity

CVSS v3.1/v4.0 vectors are preserved when supplied by an upstream authority. Risk prioritization additionally considers exploitability, affected artifact reachability, fix availability, and whether a vulnerable component is present in a released artifact.
