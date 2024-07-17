//
//  MissionScrollView.swift
//  Moonshot
//
//  Created by Xinlei Feng on 7/16/24.
//

import SwiftUI

struct CrewScrollView: View {
    let crew: [MissionView.CrewMember]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.role) { crewMember in
                    NavigationLink {
                        AstronautView(astronaut: crewMember.astronaut)
                    } label: {
                        HStack {
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .clipShape(.capsule)
                                .overlay(
                                    Capsule()
                                        .strokeBorder(.white, lineWidth: 1)
                                )

                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .foregroundStyle(.white)
                                    .font(.headline)

                                Text(crewMember.role)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct CrewScrollView_Previews: PreviewProvider {
    static var previews: some View {
        let missions: [Mission] = Bundle.main.decode("missions.json")
        let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

        let crew = missions[0].crew.compactMap { member -> MissionView.CrewMember? in
            guard let astronaut = astronauts[member.name] else {
                fatalError("Missing astronaut \(member.name)")
            }
            return MissionView.CrewMember(role: member.role, astronaut: astronaut)
        }

        CrewScrollView(crew: crew)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}

