package com.zeus.controller;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.apache.commons.io.IOUtils; // Apache Commons IO 라이브러리 필요
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.File;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.UUID;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.zeus.domain.Item;
import com.zeus.service.ItemService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@MapperScan(basePackages = "com.zeus.mapper")
@RequestMapping("/item")
public class ItemController {

	@Autowired
	private ItemService itemService;

	// application.properties 에서 upload.path에 저장된 값을 주입
	@Value("${upload.path}")
	private String uploadPath;

	@GetMapping("/createForm")
	public String itemCreateForm(Model model) {
		log.info("createForm");
		return "item/createForm";
	}

	@PostMapping("/create")
	public String itemCreate(Item item, Model model) throws IOException, Exception {
		log.info("create item" + item.toString());
		// 1. 파일업로드한것을 가져올것
		MultipartFile file = item.getPicture();
		// 2. 파일정보를 로그파일에 기록한다.
		log.info("originalName:" + file.getOriginalFilename());
		log.info("size:" + file.getSize());
		log.info("contentType:" + file.getContentType());
		// 3. 파일을 외장하드에 저장
		String createdFileName = uploadFile(file.getOriginalFilename(), file.getBytes()); // 이미지이름과 파일바이트
		item.setUrl(createdFileName);
		// 5. 테이블에 이미지 전체 정보를
		int count = itemService.create(item);

		if (count > 0) {
			model.addAttribute("message", "%s 상품등록이 성공".formatted(file.getOriginalFilename()));
			return "item/success";
		}
		model.addAttribute("message", "%s 상품등록이 실패".formatted(file.getOriginalFilename()));
		return "item/failed";
	}

	@GetMapping("/list")
	public String itemList(Model model) throws Exception {
		log.info("itemList");
		List<Item> itemList = itemService.list();
		model.addAttribute("itemList", itemList);
		return "item/list";
	}

	@GetMapping("/detail")
	public String itemList(Item i, Model model) throws Exception {
		log.info("detail");
		Item itemList = itemService.read(i);
		model.addAttribute("item", i);
		return "item/detail";
	}

	// 화면을 요ㅗ청하는 것이 아니고, 데이타를 보내줄 것을 요청.
	@ResponseBody
	@GetMapping("/display")
	public ResponseEntity<byte[]> itemDisplay(Item item) throws Exception {
		// 파일을
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;

		String url = itemService.getPicture(item);
		log.info("File url:" + url);

		String fileName = itemService.getPicture(item);
		log.info("FILE NAME: " + fileName);
		try {
			// String url = 2687a8b-4d6f-41c3-91cc-16286d16dc73_kitten-1.jpg
			// 파일명의 확장자 가져옴 String formatName = "jpg";
			String formatName = url.substring(url.lastIndexOf(".") + 1);
			// 확장자가 jpg라면 MediaType.IMAGE_JEPG
			MediaType mType = getMediaType(formatName);
			// 클라이언트 <-> 서버 (header, body)
			HttpHeaders headers = new HttpHeaders();
			// 이미지파일을 inputstream 가져옴.
			in = new FileInputStream(uploadPath + File.separator + url);
			// 이미지파일타입이 널이 아니라면, 헤더에 이미지타입을 저장
			if (mType != null) {
				headers.setContentType(mType);
			}
			// IOUtils.toByteArray(in) : inputstream 저장된 파일을 byte[] 변환한다.
			entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
		} finally {
			in.close();
		}
		return entity;
	}

	@GetMapping("/updateForm")
	public String itemUpdateForm(Item i, Model model) throws Exception {
		log.info("/updateForm item" + i.toString());
		Item item = itemService.read(i);
		model.addAttribute("item", item);
		return "item/updateForm";
	}

	private MediaType getMediaType(String form) {
		String formatName = form.toUpperCase();
		if (formatName != null) {
			if (formatName.equals("JPG")) {
				return MediaType.IMAGE_JPEG;
			}
			if (formatName.equals("GIF")) {
				return MediaType.IMAGE_GIF;
			}
			if (formatName.equals("PNG")) {
				return MediaType.IMAGE_PNG;
			}
		}
		return null;
	}

	@PostMapping("/update")
	public String itemUpdate(Item item, Model model) throws Exception {
		log.info("/update item" + item.toString());

		MultipartFile file = item.getPicture();
		String oldUrl = null; // if문 밖에서 미리 선언 (나중에 삭제할 때 사용)

		// 1. 새로운 파일이 업로드되었는지 확인
		if (file != null && file.getSize() > 0) {
			// 기존 파일 정보를 가져옴 (삭제를 위해)
			Item oldItem = itemService.read(item);
			oldUrl = oldItem.getUrl();

			// 새로운 파일 정보 출력 및 저장
			log.info("New OriginalName: " + file.getOriginalFilename());
			log.info("New Size: " + file.getSize());

			String createdFileName = uploadFile(file.getOriginalFilename(), file.getBytes());
			item.setUrl(createdFileName); // 새로운 파일명으로 업데이트
		}

		// 2. DB 업데이트 실행
		int count = itemService.update(item);

		if (count > 0) {
			// DB 수정 성공 시에만 이전 이미지 파일을 실제로 삭제
			if (oldUrl != null) {
				deleteFile(oldUrl);
			}
			model.addAttribute("message", "상품수정 성공");
			return "item/success";
		}

		model.addAttribute("message", "상품수정 실패");
		return "item/failed";
	}

	@GetMapping("/delete")
	public String itemDelte(Item item, Model model) throws Exception {
		log.info("/delete item = " + item.toString());
		String url = itemService.getPicture(item);
		int count = itemService.delete(item);

		if (count > 0) {
			// 테이블에 수정내용이 완료가 되고 그리고 나서 이전 이미지 파일을 삭제한다.
			if (url != null)
				deleteFile(url);
			{
				model.addAttribute("message", "%d상품삭제 성공".formatted(item.getId()));
				return "item/success";

			}
		}

		model.addAttribute("message", "상품삭제 실패".formatted(item.getId()));
		return "item/failed";
	}

	// 외부저장소 자료업로드 파일명생성후 저장
	// c:/upload/"../window/system.ini" 디렉토리 탈출공격(path tarversal)
	private boolean deleteFile(String fileName) throws Exception {
		if (fileName.contains("..")) {
			throw new IllegalArgumentException("잘못된 경로 입니다.");
		}
		File file = new File(uploadPath, fileName);
		return (file.exists() == true) ? (file.delete()) : (false);
	}

	private String uploadFile(String originalName, byte[] fileData) throws Exception {
		UUID uid = UUID.randomUUID(); // 절대 중복되지 않는 문자열 생성
		// cdc39bc0-a135-4f2b-8526-801ff1ee1b46_도훈.jpg
		String createdFileName = uid.toString() + "_" + originalName;
		// new File(D:/upload", cdc39bc0-a135-4f2b-8526-801ff1ee1b46_도훈.jpg)
		// D:/upload", cdc39bc0-a135-4f2b-8526-801ff1ee1b46_도훈.jpg 내용이 없는 파일명만 생성
		File target = new File(uploadPath, createdFileName);
		// (파일내용이 있는 바이트배열) byte[] fileData 을
		// D:/upload", cdc39bc0-a135-4f2b-8526-801ff1ee1b46_도훈.jpg 복사진행
		FileCopyUtils.copy(fileData, target);
		return createdFileName;
	}
}
