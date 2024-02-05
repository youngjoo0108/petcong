package com.example.ssafy.petcong.matching.model;

import com.example.ssafy.petcong.matching.model.entity.ProfileRecord;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
@AllArgsConstructor
public class ChoiceRes {
    private String targetLink;
    private ProfileRecord profile;
    private List<String> questions;
}
