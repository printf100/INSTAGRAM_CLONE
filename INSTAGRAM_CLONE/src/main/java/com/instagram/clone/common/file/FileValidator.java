package com.instagram.clone.common.file;

import org.springframework.stereotype.Service;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import lombok.Data;

@Service
public class FileValidator implements Validator {

	@Override
	public boolean supports(Class<?> clazz) {
		// 객체의 타입 검증
		return false;
	}

	
	// 제공된 target 객체의 유효성 검사. (error 객체를 상룡해 유효성 검사결과에대한 오류보고 가능)
	@Override
	public void validate(Object target, Errors errors) {
		UploadFile file = (UploadFile) target;

		if (file.getMpfile().getSize() == 0) {
			// 파일객체의 사이즈가 0 이라면 오류!
			// 현재 객체의 지정된 필드에 대한 오류등록가능.
			errors.rejectValue("mpfile", "fileNPE", "Please select a file");
		}
	}

}
