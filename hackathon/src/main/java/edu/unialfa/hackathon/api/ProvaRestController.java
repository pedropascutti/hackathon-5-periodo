package edu.unialfa.hackathon.api;

import edu.unialfa.hackathon.dto.ProvaDTO;
import edu.unialfa.hackathon.model.Prova;
import edu.unialfa.hackathon.service.ProvaService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@AllArgsConstructor
@RequestMapping("/api/provas")
public class ProvaRestController {

    private final ProvaService provaService;

    @GetMapping("/disciplina/{id}")
    public ResponseEntity<List<ProvaDTO>> listarPorDisciplina(@PathVariable Long id) {
        List<Prova> provas = provaService.listarPorDisciplina(id);
        List<ProvaDTO> dtos = provas.stream().map(ProvaDTO::fromEntity).toList();

        return ResponseEntity.ok(dtos);
    }


}
