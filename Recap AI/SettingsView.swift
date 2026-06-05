//
//  SettingsView.swift
//  Recap AI
//
//  Created by Hiren on 03/06/26.
//


import SwiftUI

struct SettingsView: View {
    @State private var apiKey: String = KeychainManager.get(key: "openai_api_key") ?? ""
    @State private var isEditing = false
    @State private var isSaved = false

    var body: some View {
        NavigationStack {
            Form {

                // MARK: - API Key Section
                Section {
                    if isEditing {
                        TextField("sk-proj-...", text: $apiKey)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .font(.system(.body, design: .monospaced))

                        HStack {
                            Button("Save") {
                                KeychainManager.save(key: "openai_api_key", value: apiKey)
                                isEditing = false
                                isSaved = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    isSaved = false
                                }
                            }
                            .buttonStyle(.borderedProminent)

                            Button("Cancel") {
                                apiKey = KeychainManager.get(key: "openai_api_key") ?? ""
                                isEditing = false
                            }
                            .foregroundStyle(.secondary)
                        }

                    } else {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(maskedKey)
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundStyle(apiKey.isEmpty ? .red : .primary)
                                if apiKey.isEmpty {
                                    Text("Required to use the app")
                                        .font(.caption)
                                        .foregroundStyle(.red)
                                }
                            }
                            Spacer()
                            Button("Edit") {
                                isEditing = true
                            }
                            .foregroundStyle(.blue)
                        }
                    }

                    if isSaved {
                        Label("API key saved to Keychain", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.caption)
                    }

                } header: {
                    Text("OpenAI API Key")
                } footer: {
                    Text("Your key is stored securely in the iOS Keychain — never in source code or iCloud.")
                }

                // MARK: - How to get key
                Section("Get an API Key") {
                    Link(destination: URL(string: "https://platform.openai.com/api-keys")!) {
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundStyle(.orange)
                            Text("Open OpenAI Platform")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                // MARK: - Tech Stack
                Section("Tech Stack") {
                    LabeledContent {
                        Text("Whisper")
                    } label: {
                        Label("Transcription", systemImage: "waveform")
                    }

                    LabeledContent {
                        Text("GPT-4o")
                    } label: {
                        Label("Summarization", systemImage: "sparkles")
                    }

                    LabeledContent {
                        Text("On-device")
                    } label: {
                        Label("Storage", systemImage: "internaldrive")
                    }

                    LabeledContent {
                        Text("iOS Keychain")
                    } label: {
                        Label("Security", systemImage: "lock.fill")
                    }
                }

                // MARK: - App Info
                Section("About") {
                    LabeledContent("App", value: "Recap AI")
                    LabeledContent("Version", value: "1.0.0")
                    LabeledContent("Built with", value: "SwiftUI + SwiftData")
                }
            }
            .navigationTitle("Settings")
        }
    }

    private var maskedKey: String {
        guard !apiKey.isEmpty else { return "No API key set" }
        return "sk-•••••••••••••••••••" + apiKey.suffix(4)
    }
}
