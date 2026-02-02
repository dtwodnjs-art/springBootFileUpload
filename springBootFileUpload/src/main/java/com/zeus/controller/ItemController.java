package com.zeus.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.UUID;

import org.apache.commons.io.IOUtils;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
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
		log.info("/createForm");
		return "item/createForm";
	}

	@PostMapping("/create")
	public String itemCreate(Item item, Model model) throws IOException, Exception {
		log.info("/create item=" + item.toString());
		// 1. 파일업로드한것을 가져올것
		MultipartFile file = item.getPicture();
		// 2. 파일정보를 로그파일에 기록한다.
		log.info("originalName:" + file.getOriginalFilename());
		log.info("size: " + file.getSize());
		log.info("contentType:" + file.getContentType());
		// 3. 파일을 외장하드에 저장
		String createdFileName = uploadFile(file.getOriginalFilename(), file.getBytes());

		// 4. 저장된 새로운생성된 파일명을 item 도메인에 저장.
		item.setUrl(createdFileName);
		// 5. 테이블에 상품화면정보를 저장
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
		log.info("/itemList");
		List<Item> itemList = itemService.list();
		model.addAttribute("itemList", itemList);
		return "item/list";
	}

	@GetMapping("/detail")
	public String itemDetail(Item i, Model model) throws Exception {
		log.info("/detail");
		Item item = itemService.read(i);
		model.addAttribute("item", item);
		return "item/detail";
	}

	// 화면을 요청하는것이 아니고, 데이타를 보내줄것을 요청.
	@ResponseBody
	@GetMapping("/display")
	public ResponseEntity<byte[]> itemDisplay(Item item) throws Exception {
		log.info("itemDisplay: ");
		// 파일을 읽기 위한 스트림
		InputStream in = null;
		ResponseEntity<byte[]> entity = null;

		String url = itemService.getPicture(item);
		log.info("FILE url: " + url);

		try {
			// String url = 26387a8b-4d6f-41c3-91cc-16286d16dc7e_kitten-1.jpg
			// 파일명의 확장자 가져옴 String formatName = "jpg";
			String formatName = url.substring(url.lastIndexOf(".") + 1);
			// 확장자가 jpg라면 MediaType.IMAGE_JPEG
			MediaType mType = getMediaType(formatName);
			// 클라이언트 <-> 서버(header, body)
			HttpHeaders headers = new HttpHeaders();
			// 이미지파일을 inputstream 가져옴.
			in = new FileInputStream(uploadPath + File.separator + url);
			// 이미지파일타입이 널이 아니라면, 헤더에 이미지타입을 저장
			if (mType != null) {
				headers.setContentType(mType);
			}
			// IOUtils.toByteArray(in) : inputstream 저장된 파일을 byte[] 변환한한다.
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
		log.info("/updateForm item= " + i.toString());
		Item item = itemService.read(i);
		model.addAttribute("item", item);
		return "item/updateForm";
	}

	@PostMapping("/update")
    public String itemUpdate(Item item, Model model) throws Exception {
        log.info("/update item= " + item.toString());
        MultipartFile file = item.getPicture();
        Item oldItem = itemService.read(item);

        if (file != null && file.getSize() > 0) {
            //새로운업로드 이미지파일
            log.info("originalName: " + file.getOriginalFilename());
            log.info("size: " + file.getSize());
            log.info("contentType: " + file.getContentType());
            String createdFileName = uploadFile(file.getOriginalFilename(), file.getBytes());
            item.setUrl(createdFileName);
            int count = itemService.update(item);
            if (count > 0) {
                //테이블에 수정내용이 완료가 되고 그리고 나서 이전 이미지 파일을 삭제한다.
                if(oldItem.getUrl() != null) deleteFile(oldItem.getUrl());
                model.addAttribute("message", "%s 상품수정 성공".formatted(item.getName()));
                return "item/success";
            }
        }else {
            item.setUrl(oldItem.getUrl());
            int count = itemService.update(item);
            if (count > 0) {
                model.addAttribute("message", "%s 상품수정 성공".formatted(item.getName()));
                return "item/success";
            }
        }

        model.addAttribute("message", "%s 상품수정 실패".formatted(item.getName()));
        return "item/failed";
    }
	
	
	@GetMapping("/delete") 
	public String itemDelete(Item item, Model model) throws Exception{ 
		log.info("/delete item=" + item.toString());
		String url = itemService.getPicture(item);
		int count = itemService.delete(item);  
		
		if (count > 0) {
			//테이블에 수정내용이 완료가 되고 그리고 나서 이전 이미지 파일을 삭제한다.
			if(url != null) deleteFile(url);
			model.addAttribute("message", "%d 상품삭제 성공".formatted(item.getId()));
			return "item/success";
		}
		model.addAttribute("message", "%d 상품삭제 실패".formatted(item.getId()));
		return "item/failed";
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

	private String uploadFile(String originalName, byte[] fileData) throws Exception {
		// 절대중복되지 않는 문자열 생성 (cdc39bc0-a135-4f2b-8526-018ff1ee1b46)
		UUID uid = UUID.randomUUID();
		// cdc39bc0-a135-4f2b-8526-018ff1ee1b46_도훈.jpg
		String createdFileName = uid.toString() + "_" + originalName;
		// new File("D:/upload", "cdc39bc0-a135-4f2b-8526-018ff1ee1b46_도훈.jpg")
		// D:/upload/cdc39bc0-a135-4f2b-8526-018ff1ee1b46_도훈.jpg 내용이없는 파일명만 생성
		File target = new File(uploadPath, createdFileName);
		// (파일내용이 있는 바이트배열)byte[] fileData 을
		// D:/upload/cdc39bc0-a135-4f2b-8526-018ff1ee1b46_도훈.jpg 복사진행
		FileCopyUtils.copy(fileData, target);
		return createdFileName;
	}

	// 외부저장소 자료업로드 파일명생성후 저장
	// D:/upload/"../window/system.ini" 디렉토리 탈출공격(path tarversal)
	private boolean deleteFile(String fileName) throws Exception {
		if (fileName.contains("..")) {
			throw new IllegalArgumentException("잘못된 경로 입니다.");
		}
		File file = new File(uploadPath, fileName);
		return (file.exists() == true) ? (file.delete()) : (false);
	}
}