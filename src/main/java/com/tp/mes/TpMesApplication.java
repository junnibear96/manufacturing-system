package com.tp.mes;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
@MapperScan({ "com.tp.mes.app.hr.mapper", "com.tp.mes.app.factory.mapper", "com.tp.mes.app.prod.mapper",
    "com.tp.mes.app.inventory.mapper", "com.tp.mes.app.inventory.repository", "com.tp.mes.app.prod.repository" })
public class TpMesApplication extends SpringBootServletInitializer {

  public static void main(String[] args) {
    SpringApplication.run(TpMesApplication.class, args);
  }

  @Override
  protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
    return builder.sources(TpMesApplication.class);
  }
}
