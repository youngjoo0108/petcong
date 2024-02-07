package com.example.ssafy.petcong.matching.model;

import com.example.ssafy.petcong.matching.model.entity.Icebreaking;
import com.example.ssafy.petcong.matching.model.entity.ProfileRecord;
import lombok.*;

import java.util.List;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChoiceRes {
    private String targetUid;
    private ProfileRecord profile;
    private List<Icebreaking> icebreakingList;
}
