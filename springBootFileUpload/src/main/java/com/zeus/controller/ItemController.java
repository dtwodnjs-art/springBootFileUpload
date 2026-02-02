package com.zeus.controller;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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
   
   //application.properties 에서 upload.path에 저장된 값을 주입
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
      //3. 파일을 외장하드에 저장
      String createdFileName = uploadFile(file.getOriginalFilename(), file.getBytes()); //이미지이름과 파일바이트
      item.setUrl(createdFileName);
      //5. 테이블에 이미지 전체 정보를 
      int count = itemService.create(item);
      
      if(count > 0) {
         model.addAttribute("message", "%s 상품등록이 성공".formatted(file.getOriginalFilename()));
         return "item/success";
      }
      model.addAttribute("message", "%s 상품등록이 실패".formatted(file.getOriginalFilename()));
      return "item/failed";
   }
   private String uploadFile(String originalName, byte[] fileData) throws Exception { 
   UUID uid = UUID.randomUUID(); //중복방지
   //cdc39bc0-a135-4f2b-8526-801ff1ee1b46_도훈.jpg
   String createdFileName = uid.toString() + "_" + originalName; 
   //new File(D:/upload", cdc39bc0-a135-4f2b-8526-801ff1ee1b46_도훈.jpg)
   //D:/upload", cdc39bc0-a135-4f2b-8526-801ff1ee1b46_도훈.jpg 내용이 없는 파일명만 생성
   File target = new File(uploadPath, createdFileName); 
   //(파일내용이 있는 바이트배열) byte[] fileData 을 
   //D:/upload", cdc39bc0-a135-4f2b-8526-801ff1ee1b46_도훈.jpg 복사진행
   FileCopyUtils.copy(fileData, target); 
   return createdFileName; 
   } 
}