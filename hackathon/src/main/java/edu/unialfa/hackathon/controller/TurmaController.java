package edu.unialfa.hackathon.controller;

import edu.unialfa.hackathon.model.Turma;
import edu.unialfa.hackathon.service.TurmaService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@AllArgsConstructor
@RequestMapping("/turmas")
public class TurmaController {

    private final TurmaService turmaService;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("turmas", turmaService.listarTodas());
        return "turmas/lista"; // exemplo de template
    }

    @GetMapping("/nova")
    public String novaTurmaForm(Model model) {
        model.addAttribute("turma", new Turma());
        return "turmas/form";
    }

    @PostMapping("/salvar")
    public String salvar(@ModelAttribute Turma turma) {
        turmaService.salvar(turma);
        return "redirect:/turmas";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model) {
        model.addAttribute("turma", turmaService.buscarPorId(id));
        return "turmas/form";
    }

    @GetMapping("/deletar/{id}")
    public String deletar(@PathVariable Long id) {
        turmaService.deletarPorId(id);
        return "redirect:/turmas";
    }
}