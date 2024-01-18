package com.example.ssafy.petcong.matching.service;

public interface OnlineUsersService {
    void addUserToQueue(int userId);

    int removeUserFromQueue();

    int sizeOfQueue();
}
