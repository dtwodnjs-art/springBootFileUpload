package com.zeus;

import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class SpringBootFileUploadApplicationTests {

	@Test
	void contextLoads() {
		UUID uid = UUID.randomUUID();// 중복방지
	}

}
