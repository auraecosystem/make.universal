-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- Table: Wallet Holder (the subject/owner of the wallet)
CREATE TABLE holder (
    holder_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    did            TEXT UNIQUE NOT NULL, -- Decentralized Identifier
    name           TEXT,
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: Issuers (entities that issue credentials)
CREATE TABLE issuer (
    issuer_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    did            TEXT UNIQUE NOT NULL,
    name           TEXT,
    endpoint       TEXT, -- optional API endpoint
    public_key_jwk TEXT, -- JSON Web Key for verification
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: Verifiable Credentials
CREATE TABLE credential (
    credential_id  INTEGER PRIMARY KEY AUTOINCREMENT,
    holder_id      INTEGER NOT NULL,
    issuer_id      INTEGER NOT NULL,
    vc_id          TEXT UNIQUE NOT NULL, -- Credential ID (URI)
    type           TEXT NOT NULL, -- e.g., ["VerifiableCredential", "UniversityDegreeCredential"]
    context        TEXT NOT NULL, -- JSON array of @context
    issuance_date  DATETIME NOT NULL,
    expiration_date DATETIME,
    credential_subject TEXT NOT NULL, -- JSON object
    proof          TEXT NOT NULL, -- JSON proof object
    raw_vc         TEXT NOT NULL, -- Full VC JSON for reference
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (holder_id) REFERENCES holder(holder_id) ON DELETE CASCADE,
    FOREIGN KEY (issuer_id) REFERENCES issuer(issuer_id) ON DELETE CASCADE
);

-- Table: Presentations (when credentials are shared)
CREATE TABLE presentation (
    presentation_id INTEGER PRIMARY KEY AUTOINCREMENT,
    holder_id       INTEGER NOT NULL,
    vp_id           TEXT UNIQUE NOT NULL, -- Verifiable Presentation ID
    type            TEXT NOT NULL, -- e.g., ["VerifiablePresentation"]
    context         TEXT NOT NULL, -- JSON array of @context
    verifiable_credentials TEXT NOT NULL, -- JSON array of embedded VCs
    proof           TEXT NOT NULL, -- JSON proof object
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (holder_id) REFERENCES holder(holder_id) ON DELETE CASCADE
);

-- Table: Keys (for signing and verification)
CREATE TABLE key_pair (
    key_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    holder_id      INTEGER NOT NULL,
    type           TEXT NOT NULL, -- e.g., Ed25519, secp256k1
    public_key_jwk TEXT NOT NULL,
    private_key_jwk TEXT, -- optional, encrypted
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (holder_id) REFERENCES holder(holder_id) ON DELETE CASCADE
);

-- Indexes for performance
CREATE INDEX idx_credential_holder ON credential(holder_id);
CREATE INDEX idx_credential_issuer ON credential(issuer_id);
CREATE INDEX idx_presentation_holder ON presentation(holder_id);
