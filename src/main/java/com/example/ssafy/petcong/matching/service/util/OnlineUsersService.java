package com.example.ssafy.petcong.matching.service.util;

public interface OnlineUsersService {
    void addUserIdToQueue(int userId);

    int removeUserIdFromQueue();

    int sizeOfQueue();
}
