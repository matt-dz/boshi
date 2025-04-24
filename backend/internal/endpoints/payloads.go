package endpoints

import (
	"github.com/jackc/pgx/v5/pgtype"
)

// Metadata for the OAuth2 client.
type clientMetadata struct {
	ClientID                string   `json:"client_id"`
	ClientName              string   `json:"client_name"`
	ClientURI               string   `json:"client_uri"`
	RedirectURIs            []string `json:"redirect_uris"`
	GrantTypes              []string `json:"grant_types"`
	Scope                   string   `json:"scope"`
	ResponseTypes           []string `json:"response_types"`
	TokenEndpointAuthMethod string   `json:"token_endpoint_auth_method"`
	ApplicationType         string   `json:"application_type"`
	DpopBoundAccessTokens   bool     `json:"dpop_bound_access_tokens"`
}

// The response for retrieving the university a user is associated with.
type universityDomain struct {
	AlphaCode string   `json:"alpha_two_code"`
	Name      string   `json:"name"`
	Domains   []string `json:"domains"`
	WebPages  []string `json:"web_pages"`
}

// Payload for retrieving a user
type getUserPayload struct {
	UserID string `json:"user_id"`
}

// Response for retrieving a user
type getUserResponse struct {
	UserID     string             `json:"did"`
	School     pgtype.Text        `json:"school"`
	VerifiedAt pgtype.Timestamptz `json:"verifiedAt"`
}

// Response for retrieving multiple users
type getUsersResponse struct {
	Users []getUserResponse `json:"users"`
}

// Payload for adding a user to the email list.
type emailListPayload struct {
	Email string `json:"email"`
}

// Payload for adding a user to the email list.
type createEmailVerificationCodePayload struct {
	UserID string `json:"user_id"`
	Email  string `json:"email"`
}

// Payload for verifying an email verification code.
type verifyEmailVerificationCodePayload struct {
	UserID string `json:"user_id"`
	Email  string `json:"email"`
	Code   string `json:"code"`
}
