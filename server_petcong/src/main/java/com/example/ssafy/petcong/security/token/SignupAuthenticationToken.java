package com.example.ssafy.petcong.security.token;

import lombok.Getter;

import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;

import java.util.Collection;

public class SignupAuthenticationToken extends AbstractAuthenticationToken {
    @Getter
    private String idToken;
    private Object principal;
    private Object credentials;

    // unauthenticated constructor
    public SignupAuthenticationToken(String idToken) {
        super(null);
        this.idToken = idToken;
        this.setAuthenticated(false);
    }

    // authenticated constructor
    public SignupAuthenticationToken(Object principal, Object credentials, Collection<? extends GrantedAuthority> authorities) {
        super(authorities);
        this.principal = principal;
        this.credentials = credentials;
        this.setAuthenticated(true);
    }

    @Override
    public Object getCredentials() {
        return this.credentials;
    }

    @Override
    public Object getPrincipal() {
        return this.principal;
    }

    // This factory method can be safely used by any code that wishes to create a unauthenticated
    public static SignupAuthenticationToken unauthenticated(String idToken) {
        return new SignupAuthenticationToken(idToken);
    }

    // This factory method can be safely used by any code that wishes to create a authenticated
    public static SignupAuthenticationToken authenticated(Object principal, Object credentials,
                                                            Collection<? extends GrantedAuthority> authorities) {
        return new SignupAuthenticationToken(principal, credentials, authorities);
    }
}
