using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace LibWindowsSandbox.Models
{
    public class SandboxConfig
    {
        public SandboxConfig() { }

        public SandboxConfig(List<MappedFolder> mappedFolders)
        {
            this.MappedFolders = mappedFolders;
        }

        public SandboxConfig(List<MappedFolder> mappedFolders, List<String> logonCommands)
        {
            this.MappedFolders = mappedFolders;
            this.LogonCommands = logonCommands;
        }

        public SandboxConfig(List<String> logonCommands)
        {
            this.LogonCommands = logonCommands;
        }

        public SandboxConfig(List<MappedFolder> mappedFolders, List<String> logonCommands, Boolean networking, Boolean vGPU, Boolean audioInput, Boolean videoInput, Boolean protectedClient,Boolean printerRedirection, Boolean clipboardRedirection, Int64 memoryInMB)
        {
            this.MappedFolders = mappedFolders;
            this.LogonCommands = logonCommands;
            this.Networking = networking;
            this.vGPU = vGPU;
            this.AudioInput = audioInput;
            this.VideoInput = videoInput;
            this.ProtectedClient = protectedClient;
            this.PrinterRedirection = printerRedirection;
            this.ClipboardRedirection = clipboardRedirection;
            this.MemoryInMB = memoryInMB;
        }

        [JsonPropertyName("mappedFolders")]
        public List<MappedFolder> MappedFolders { get; set; }

        [JsonPropertyName("logonCommands")]
        public List<String> LogonCommands { get; set; }

        [JsonPropertyName("networking")]
        public Boolean Networking { get; set; }

        [JsonPropertyName("vGpu")]
        public Boolean vGPU { get; set; }

        [JsonPropertyName("audioInput")]
        public Boolean AudioInput { get; set; }

        [JsonPropertyName("videoInput")]
        public Boolean VideoInput { get; set; }

        [JsonPropertyName("protectedClient")]
        public Boolean ProtectedClient { get; set; }

        [JsonPropertyName("printerRedirection")]
        public Boolean PrinterRedirection { get; set; }

        [JsonPropertyName("clipboardRedirection")]
        public Boolean ClipboardRedirection { get; set; }

        [JsonPropertyName("memoryInMB")]
        public Int64 MemoryInMB { get; set; }
    }
}