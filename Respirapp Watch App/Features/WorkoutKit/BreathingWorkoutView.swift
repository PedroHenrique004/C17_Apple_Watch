import SwiftUI
import WorkoutKit

struct BreathingWorkoutView: View {
    
    @Environment(ThemeManager.self) private var theme
    @State private var showWorkoutPreview = false
    
    private let workoutPlan = WorkoutPlan(.custom(RespirappWorkoutBuilder.makeBreathingWorkout()))
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Treino de Respiração")
                .font(.headline)
            
            Text("Envie uma sessão guiada de respiração para o app Treino do seu relógio.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Enviar para o Watch") {
                showWorkoutPreview = true
            }
            .buttonStyle(.borderedProminent)
            .tint(theme.accent)
        }
        .padding()
        .workoutPreview(workoutPlan, isPresented: $showWorkoutPreview)
    }
}

#Preview {
    BreathingWorkoutView()
        .environment(ThemeManager())
}
