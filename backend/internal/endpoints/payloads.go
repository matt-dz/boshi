package endpoints

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

type emailListPayload struct {
	Email string `json:"email"`
}

type createEmailVerificationCodePayload struct {
	UserID string `json:"user_id"`
	Email  string `json:"email"`
}

type verifyEmailVerificationCodePayload struct {
	UserID string `json:"user_id"`
	Email  string `json:"email"`
	Code   string `json:"code"`
}
