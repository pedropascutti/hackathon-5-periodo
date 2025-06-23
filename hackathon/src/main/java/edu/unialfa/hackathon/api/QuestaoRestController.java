package edu.unialfa.hackathon.api;

import edu.unialfa.hackathon.dto.QuestaoDTO;
import edu.unialfa.hackathon.model.Questao;
import edu.unialfa.hackathon.service.QuestaoService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@AllArgsConstructor
@RequestMapping("/api/questoes")
public class QuestaoRestController {

    private final QuestaoService questaoService;

    @GetMapping("/prova/{id}")
    public ResponseEntity<List<QuestaoDTO>> listarPorProva(@PathVariable Long id) {
        List<Questao> questoes = questaoService.listarPorProvaId(id);
        List<QuestaoDTO> dtos = questoes.stream()
                .map(QuestaoDTO::fromEntity)
                .toList();
        return ResponseEntity.ok(dtos);
    }
}
