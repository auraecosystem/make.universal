# Security Policy

make.universal treats build integrity and software supply-chain security as first-class build outputs.

## Reporting

Do not open a public issue for an undisclosed vulnerability. Report privately through the repository's configured GitHub Security Advisory mechanism or the security contact documented by the maintainers.

Include affected version/commit, reproduction steps, impact, and any proposed mitigation.

## Security gates

The build security profile supports vulnerability scanning, CVE/OSV ingestion, secret and license checks, SBOM generation, SARIF export, provenance, signing, and release verification. The default policy fails CI on `critical` findings; projects may tighten that threshold but should not silently weaken it.

## Artifact trust

Release artifacts should be accompanied by checksums, an SBOM, provenance/attestation, and a signed manifest. Verification must be performed against immutable artifact digests rather than filenames alone.
