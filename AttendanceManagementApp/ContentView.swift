import SwiftUI
import Cocoa

struct ContentView: View {
    @State private var currentTime: String = ""
    @State private var startTime: String = ""
    @State private var endTime: String = ""
    @State private var workDuration: String = ""
    
    var body: some View {
        VStack {
            Image(systemName: "clock.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .padding()
            
            Text("現在時刻: \(currentTime)")
                .font(.title)
                .padding()
            
            Button(action: {
                startTime = currentTime
            }) {
                Text("始業")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .padding(.all)
            
            Text("始業時刻: \(startTime)")
                .padding()
            
            Button(action: {
                endTime = currentTime
                calculateWorkDuration()
            }) {
                Text("終業")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)
            
            Text("終業時刻: \(endTime)")
                .multilineTextAlignment(.center)
                .padding()
            
            if !workDuration.isEmpty {
                Text("実働時間: \(workDuration)")
                    .font(.headline)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            startClock()
            registerSleepNotification()
            registerWakeNotification()
        }
    }
    
    func startClock() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            currentTime = formatter.string(from: Date())
        }
    }
    
    func calculateWorkDuration() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        
        guard let start = formatter.date(from: startTime),
              let end = formatter.date(from: endTime) else {
            return
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: start, to: end)
        
        if let hour = components.hour, let minute = components.minute, let second = components.second {
            workDuration = String(format: "%02d:%02d:%02d", hour, minute, second)
        }
    }
    
    func registerSleepNotification() {
        let notificationCenter = NSWorkspace.shared.notificationCenter
        notificationCenter.addObserver(forName: NSWorkspace.willSleepNotification, object: nil, queue: nil) { _ in
            endTime = currentTime
            calculateWorkDuration()
        }
    }
    
    func registerWakeNotification() {
        let notificationCenter = NSWorkspace.shared.notificationCenter
        notificationCenter.addObserver(forName: NSWorkspace.didWakeNotification, object: nil, queue: nil) { _ in
            startTime = currentTime
        }
    }
}

#Preview {
    ContentView()
}
