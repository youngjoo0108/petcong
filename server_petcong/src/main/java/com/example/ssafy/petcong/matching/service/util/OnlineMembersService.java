package com.example.ssafy.petcong.matching.service.util;

public interface OnlineMembersService {
    void addMemberIdToQueue(int memberId);

    int removeMemberIdFromQueue();

    int sizeOfQueue();

    void buildOnlineMemberQueue();
}
