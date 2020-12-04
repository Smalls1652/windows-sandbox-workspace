using System;
using System.Text.Json.Serialization;

namespace LibWindowsSandbox.Models
{
    public class MappedFolder
    {
        public MappedFolder() { }

        public MappedFolder(string hostFolder, string sandboxFolder, Boolean readOnly)
        {
            this.HostFolder = hostFolder;
            this.SandboxFolder = sandboxFolder;
            this.ReadOnly = readOnly;
        }

        [JsonPropertyName("hostFolder")]
        public String HostFolder { get; set; }

        [JsonPropertyName("sandboxFolder")]
        public String SandboxFolder { get; set; }

        [JsonPropertyName("readOnly")]
        public Boolean ReadOnly { get; set; }
    }
}