package edu.unialfa.hackathon.controller;

import edu.unialfa.hackathon.model.Disciplina;
import edu.unialfa.hackathon.service.DisciplinaService;
import edu.unialfa.hackathon.service.TurmaService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@AllArgsConstructor
@RequestMapping("/disciplinas")
public class DisciplinaController {

    private final DisciplinaService disciplinaService;
    private final TurmaService turmaService;
    //private final ProfessorService professorService;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("disciplinas", disciplinaService.listarTodas());
        return "disciplinas/lista";
    }

    @GetMapping("/nova")
    public String novaDisciplinaForm(Model model) {
        model.addAttribute("disciplina", new Disciplina());
        model.addAttribute("turmas", turmaService.listarTodas());
        //model.addAttribute("professores", professorService.listarTodos()); // você vai precisar deste service
        return "disciplinas/form";
    }

    @PostMapping("/salvar")
    public String salvar(@ModelAttribute Disciplina disciplina) {
        disciplinaService.salvar(disciplina);
        return "redirect:/disciplinas";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model) {
        model.addAttribute("disciplina", disciplinaService.buscarPorId(id));
        model.addAttribute("turmas", turmaService.listarTodas());
        //model.addAttribute("professores", professorService.listarTodos());
        return "disciplinas/form";
    }

    @GetMapping("/deletar/{id}")
    public String deletar(@PathVariable Long id) {
        disciplinaService.deletarPorId(id);
        return "redirect:/disciplinas";
    }
}