package com.example.ssafy.petcong.matching.model.entity;


import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class Icebreaking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "icebreaking_id")
    private int id;

    private String content;
}
