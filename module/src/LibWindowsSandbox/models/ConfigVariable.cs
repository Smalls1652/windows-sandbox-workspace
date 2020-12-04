using System;

namespace LibWindowsSandbox.Models
{
    public class ConfigVariable
    {
        public ConfigVariable() { }

        public ConfigVariable(string name, string content)
        {
            this.VariableName = name;
            this.Content = content;
        }

        public String VariableName { get; set; }

        public String Content { get; set; }
    }
}