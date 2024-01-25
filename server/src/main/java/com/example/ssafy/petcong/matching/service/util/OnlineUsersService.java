package com.example.ssafy.petcong.matching.service.util;

public interface OnlineUsersService {
    void addUserToQueue(int userId);

    int removeUserFromQueue();

    int sizeOfQueue();
}
