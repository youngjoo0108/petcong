package com.example.ssafy.petcong.config;

import jakarta.persistence.EntityManagerFactory;

import lombok.extern.slf4j.Slf4j;

import org.hibernate.boot.model.naming.*;
import org.springframework.boot.autoconfigure.orm.jpa.HibernateProperties;
import org.springframework.boot.autoconfigure.orm.jpa.JpaProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.boot.orm.jpa.hibernate.SpringImplicitNamingStrategy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.JpaVendorAdapter;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.TransactionManager;

import javax.sql.DataSource;
import java.util.Properties;

@Slf4j
@Configuration
@EnableJpaRepositories("com.example.ssafy.petcong.*.repository")
public class JpaConfig {
    @Bean
    public PhysicalNamingStrategy physicalNamingStrategy() {
        return new CamelCaseToUnderscoresNamingStrategy();
    }

    @Bean
    public ImplicitNamingStrategy implicitNamingStrategy() {
        return new SpringImplicitNamingStrategy();
    }

    @Bean
    @ConfigurationProperties("spring.datasource.hikari")
    public DataSource dataSource() {
        return DataSourceBuilder.create().build();
    }

//    @Bean
//    public JpaVendorAdapter jpaVendorAdapter() {
//        HibernateJpaVendorAdapter hibernateJpaVendorAdapter = new HibernateJpaVendorAdapter();
//        return hibernateJpaVendorAdapter;
//    }

    @Bean
    public LocalContainerEntityManagerFactoryBean entityManagerFactory(DataSource dataSource, JpaVendorAdapter jpaVendorAdapter) {
        LocalContainerEntityManagerFactoryBean factory = new LocalContainerEntityManagerFactoryBean();
        factory.setDataSource(dataSource);
        factory.setJpaVendorAdapter(jpaVendorAdapter);
        factory.setPackagesToScan("com.example.ssafy.petcong.*.model.entity");
        return factory;
    }

    @Bean
    public TransactionManager transactionManager(EntityManagerFactory entityManagerFactory) {
        JpaTransactionManager transactionManager = new JpaTransactionManager();
        transactionManager.setEntityManagerFactory(entityManagerFactory);
        return transactionManager;
    }

}
