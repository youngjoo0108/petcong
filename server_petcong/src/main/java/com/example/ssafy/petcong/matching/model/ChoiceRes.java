package com.example.ssafy.petcong.matching.model;

import lombok.*;

import java.util.List;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChoiceRes {
    private String targetUid;
    private List<String> skillUrlList;
    private List<String> profileImgUrlList;
}
