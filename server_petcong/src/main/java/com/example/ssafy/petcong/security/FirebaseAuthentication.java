//package com.example.ssafy.petcong.security;
//
//import org.springframework.security.authentication.AbstractAuthenticationToken;
//import org.springframework.security.core.GrantedAuthority;
//
//import java.util.Collection;
//
//public class FirebaseAuthentication extends AbstractAuthenticationToken {
//    private String idToken;
//    private Object principal;
//    private Object credentials;
//    public FirebaseAuthentication(String idToken) {
//        super(null);
//        this.idToken = idToken;
//        this.setAuthenticated(false);
//    }
//
//    public FirebaseAuthentication(Object principal, Object credentials, Collection<? extends GrantedAuthority> authorities) {
//        super(authorities);
//        this.principal = principal;
//        this.credentials = credentials;
//        this.setAuthenticated(true);
//    }
//    @Override
//    public Object getCredentials() {
//        return this.credentials;
//    }
//
//    @Override
//    public Object getPrincipal() {
//        return this.principal;
//    }
//
//    public String getIdToken() {
//        return this.idToken;
//    }
//}
