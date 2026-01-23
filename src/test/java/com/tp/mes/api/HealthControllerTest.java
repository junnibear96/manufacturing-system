package com.tp.mes.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.tp.mes.TpMesApplication;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest(classes = TpMesApplication.class)
@AutoConfigureMockMvc
class HealthControllerTest {

  @Autowired private MockMvc mockMvc;

  @Test
  void health_returns_200_even_without_db() throws Exception {
    mockMvc.perform(get("/api/health"))
        .andExpect(status().isOk());
  }
}
