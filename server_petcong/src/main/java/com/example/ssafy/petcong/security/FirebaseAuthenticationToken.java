package com.example.ssafy.petcong.security;

import lombok.Getter;

import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;

import java.util.Collection;

public class FirebaseAuthenticationToken extends AbstractAuthenticationToken {
    @Getter
    private String idToken;
    private Object principal;
    private Object credentials;

    // unauthenticated constructor
    public FirebaseAuthenticationToken(String idToken) {
        super(null);
        this.idToken = idToken;
        this.setAuthenticated(false);
    }

    // authenticated constructor
    public FirebaseAuthenticationToken(Object principal, Object credentials, Collection<? extends GrantedAuthority> authorities) {
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
    public static FirebaseAuthenticationToken unauthenticated(String idToken) {
        return new FirebaseAuthenticationToken(idToken);
    }

    // This factory method can be safely used by any code that wishes to create a authenticated
    public static FirebaseAuthenticationToken authenticated(Object principal, Object credentials,
                                                            Collection<? extends GrantedAuthority> authorities) {
        return new FirebaseAuthenticationToken(principal, credentials, authorities);
    }
}
