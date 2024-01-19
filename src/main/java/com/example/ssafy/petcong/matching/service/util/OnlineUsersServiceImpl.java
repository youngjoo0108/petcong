package com.example.ssafy.petcong.matching.service.util;

import org.springframework.stereotype.Service;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

@Service
public class OnlineUsersServiceImpl implements OnlineUsersService {
    private final BlockingQueue<Integer> onlineUserQueue = new LinkedBlockingQueue<>();

    @Override
    public void addUserToQueue(int userId) {
        try {
            onlineUserQueue.put(userId);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            // Handle interruption if needed
        }
    }

    @Override
    public int removeUserFromQueue() {
        try {
            return onlineUserQueue.take();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            // Handle interruption if needed
            return -1;
        }
    }

    @Override
    public int sizeOfQueue() {
        return onlineUserQueue.size();
    }

}
