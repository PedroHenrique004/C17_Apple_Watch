//
//  WorkoutKitService.swift
//  Respirapp Watch App
//
//  Created by Pedro Santos on 28/08/26.
//

import Foundation
import WorkoutKit
import HealthKit

enum RespirappWorkoutBuilder {
    
    /// Monta um treino estruturado de respiração guiada usando WorkoutKit.
    static func makeBreathingWorkout() -> CustomWorkout {
        
        // Aquecimento: 1 minuto de respiração livre antes de começar
        let warmup = WorkoutStep(goal: .time(60, .seconds))
        
        // Bloco principal: inspirar (4s) e expirar (6s), repetido 6 vezes
        let inhaleStep = IntervalStep(.work, goal: .time(4, .seconds))
        let exhaleStep = IntervalStep(.recovery, goal: .time(6, .seconds))
        
        var breathingBlock = IntervalBlock()
        breathingBlock.steps = [inhaleStep, exhaleStep]
        breathingBlock.iterations = 6
        
        // Desaquecimento: 30 segundos livres pra finalizar
        let cooldown = WorkoutStep(goal: .time(30, .seconds))
        
        return CustomWorkout(
            activity: .mindAndBody,
            location: .indoor,
            displayName: "Respiração Guiada — Respirapp",
            warmup: warmup,
            blocks: [breathingBlock],
            cooldown: cooldown
        )
    }
}
