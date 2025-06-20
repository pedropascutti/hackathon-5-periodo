package edu.unialfa.hackathon.controller;

import edu.unialfa.hackathon.service.ProvaService;
import edu.unialfa.hackathon.service.QuestaoService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@AllArgsConstructor
@RequestMapping("/questoes")
public class QuestaoController {

    private final ProvaService provaService;

    @GetMapping("/prova/{id}")
    public String questoes(@PathVariable Long id, Model model) {
        model.addAttribute("prova", provaService.buscarPorId(id));

        return "questoes/formulario";
    }

    @GetMapping("/prova/{id}/cadastrar")
    public String cadastrarQuestoes(@PathVariable Long id, Model model) {
        model.addAttribute("prova", provaService.buscarPorId(id));

        return "questoes/formulario";
    }
}
