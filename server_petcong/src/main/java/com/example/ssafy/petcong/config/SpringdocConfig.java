package com.example.ssafy.petcong.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.models.media.StringSchema;
import io.swagger.v3.oas.models.parameters.Parameter;

import org.springdoc.core.customizers.OperationCustomizer;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@OpenAPIDefinition(
    info = @Info(
        title = "Petcong api 명세서",
        description = "SSAFY 10기 Petcong 프로젝트의 API 명세서입니다",
        version = "v1",
        contact = @Contact(
                name = "신문영",
                email = "ztrl@naver.com"
        )
    )
)
public class SpringdocConfig {
    @Bean
    public OperationCustomizer operationCustomizer() {
        return ((operation, handlerMethod) -> {
            Parameter param = new Parameter()
                    .in(ParameterIn.HEADER.toString())
                    .schema(new StringSchema()._default("A603").name("tester"))
                    .name("tester")
                    .description("test header")
                    .required(true);
            operation.addParametersItem(param);
            return operation;
        });
    }
}
