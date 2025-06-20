package edu.unialfa.hackathon.controller;

import edu.unialfa.hackathon.model.Prova;
import edu.unialfa.hackathon.service.DisciplinaService;
import edu.unialfa.hackathon.service.ProfessorService;
import edu.unialfa.hackathon.service.ProvaService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@AllArgsConstructor
@RequestMapping("/provas")
public class ProvaController {
    private final ProvaService provaService;
    private final DisciplinaService disciplinaService;
    private final ProfessorService professorService;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("provas", provaService.listarTodos());

        return "provas/lista";
    }

    @GetMapping("/nova")
    public String novaProvaForm(Model model) {
        model.addAttribute("prova", new Prova());
        model.addAttribute("disciplinas", disciplinaService.listarTodas());
        model.addAttribute("professores", professorService.listarTodos());

        return "provas/formulario";
    }

    @PostMapping("/salvar")
    public String salvar(@ModelAttribute Prova prova) {
        provaService.salvar(prova);

        return "redirect:/provas";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model) {
        model.addAttribute("prova", provaService.buscarPorId(id));
        model.addAttribute("disciplinas", disciplinaService.listarTodas());
        model.addAttribute("professores", professorService.listarTodos());

        return "provas/formulario";
    }

    @GetMapping("/deletar/{id}")
    public String deletar(@PathVariable Long id) {
        provaService.deletarPorId(id);

        return "redirect:/provas";
    }
}
