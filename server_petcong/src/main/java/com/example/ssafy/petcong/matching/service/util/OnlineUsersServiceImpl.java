package com.example.ssafy.petcong.matching.service.util;

import com.example.ssafy.petcong.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

@Service
@RequiredArgsConstructor
public class OnlineUsersServiceImpl implements OnlineUsersService {
    private final BlockingQueue<Integer> onlineUserQueue = new LinkedBlockingQueue<>();
    private final UserRepository userRepository;

    @Override
    public void addUserIdToQueue(int userId) {
        try {
            onlineUserQueue.put(userId);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    @Override
    public int removeUserIdFromQueue() {
        try {
            return onlineUserQueue.take();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return -1;
        }
    }

    @Override
    public int sizeOfQueue() {
        return onlineUserQueue.size();
    }

    @Override
    @Scheduled(fixedRate = 1000 * 10)
    // Method to build the online user queue every 10 seconds
    public void buildOnlineUserQueue() {
        onlineUserQueue.clear();
        userRepository.findByCallableIsTrue().forEach(user -> onlineUserQueue.add(user.getUserId()));
    }

}
