package edu.unialfa.hackathon.controller;

import edu.unialfa.hackathon.dto.NotaPorDisciplinaDTO;
import edu.unialfa.hackathon.model.Aluno;
import edu.unialfa.hackathon.model.Professor;
import edu.unialfa.hackathon.model.Usuario;
import edu.unialfa.hackathon.service.AlunoService;
import edu.unialfa.hackathon.service.NotaService;
import edu.unialfa.hackathon.service.ProfessorService;
import edu.unialfa.hackathon.service.UsuarioService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@AllArgsConstructor
@RequestMapping("/notas")
public class NotaController {

    private final NotaService notaService;
    private final UsuarioService usuarioService;
    private final AlunoService alunoService;
    private final ProfessorService professorService;

    @GetMapping
    public String listarNotas(Model model) {
        Usuario usuarioLogado = usuarioService.getUsuarioLogado();
        List<NotaPorDisciplinaDTO> notasAgrupadas;

        switch (usuarioLogado.getTipoUsuario().getDescricao().toUpperCase()) {
            case "ALUNO" -> {
                Aluno aluno = alunoService.buscarPorUsuario(usuarioLogado);
                notasAgrupadas = notaService.buscarNotasDoAlunoAgrupadas(aluno.getId());
            }
            case "PROFESSOR" -> {
                Professor professor = professorService.buscarPorUsuario(usuarioLogado);
                notasAgrupadas = notaService.buscarNotasDosAlunosPorProfessorAgrupadas(professor.getId());
            }
            default -> notasAgrupadas = List.of();
        }

        model.addAttribute("notasAgrupadas", notasAgrupadas);
        return "notas/lista";
    }
}
