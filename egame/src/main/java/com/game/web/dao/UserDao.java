package com.game.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.game.web.model.Friend;
import com.game.web.model.Product;
import com.game.web.model.User;

@Repository("userDao")
public interface UserDao
{
	//회원가입
	public int userInsert(User user);
		
	//회원정보 수정
	public int userUpdate(User user);
	
	//아이디 조회
	public User userSelect(String userId);
	
	//유저 아이디 체크
	public long userCheck(String userId);
	
	//사업자번호 체크
	public User businessNumCheck(String userBusinessNum);
	
	//판매게임 정보
	public List<Product> saleSelect(Product product);
	
	//게임 판매정지
	public int waitStatusPrd(Product product);
	
	//마이페이지 판매게임
	public int countSaleGame(String userId);

	//마이페이지 보유게임
	public int countGame(String userId);

	//마이페이지 사용포인트(포인트지출합계)
	public long expenditure(String userId);
	
	//마이페이지 사용포인트(포인트환불합계)
	public long expenditureRefund(String userId);

	//마이페이지 장바구니 보유 갯수
	public int countCart(String userId);

	//마이페이지 친구 수
	public int countFriend(String userId);

	//마이페이지 문의 작성 수
	public int countQna(String userId);

	//마이페이지 문의 답변 수
	public int countQnaReview(String userId);

	//마이페이지 리뷰 작성 수
	public int countReview(String userId);

	//마이페이지 신고 작성 수
	public int countReport(String userId);

	//마이페이지 신고 처리 수
	public int countCompleteReport(String userId);
	
	//친구페이지 친구조회
	public List<Friend> friendList(Friend friend);

	//친구페이지 사이드
	public List<Friend> friendSide(String cookieUserId);

	//friendId(상대)의 frStatus 조회
	public String frStatus(Friend friend);

	//friendId(기준) - userId 로 frStatus - 2(수락대기) INSERT
	public int insertAcceptFrStatus(Friend friend);

	//cookieUserId(기준) - frUserId 로 frStatus - 1(신청) INSERT
	public int insertProposalFrStatus(Friend friend);

	//friendId(기준) - userId 로 frStatus - 4(친구) UPDATE
	public int updateRegFrStatus(Friend friend);

	//cookieUserId(기준) - frUserId 로 frStatus - 4(친구) UPDATE
	public int updateMyRegFrStatus(Friend friend);
	
	//friendId(기준) - userId 로 TBL_FRIEND DELETE
	public int deleteFrStatus(Friend friend);

	//cookieUserId(기준) - frUserId 로 TBL_FRIEND DELETE	
	public int deleteMyFrStatus(Friend friend);
	
	//프로필 사진 저장
	public int updateImg(User user);

	//유저 이미지 default로 변경
	public int updateImgToDf(String userId);
	
	//포인트 업데이트
	public int updatePoint(User user);
	
	//유저 이메일 중복체크
	public int userEmailCheck(String userEmail);
}
