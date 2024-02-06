package com.example.ssafy.petcong.matching.service.util;

import com.example.ssafy.petcong.member.repository.MemberRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

@Service
@RequiredArgsConstructor
public class OnlineMembersServiceImpl implements OnlineMembersService {
    private final BlockingQueue<Integer> onlineMemberQueue = new LinkedBlockingQueue<>();
    private final MemberRepository memberRepository;

    @Override
    public void addMemberIdToQueue(int memberId) {
        try {
            onlineMemberQueue.put(memberId);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    @Override
    public int removeMemberIdFromQueue() {
        try {
            return onlineMemberQueue.take();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return -1;
        }
    }

    @Override
    public int sizeOfQueue() {
        return onlineMemberQueue.size();
    }

    @Override
    @Scheduled(fixedRate = 1000 * 10)
    // Method to build the online member queue every 10 seconds
    public void buildOnlineMemberQueue() {
        onlineMemberQueue.clear();
        memberRepository.findByCallableIsTrue().forEach(member -> onlineMemberQueue.add(member.getMemberId()));
    }

}
