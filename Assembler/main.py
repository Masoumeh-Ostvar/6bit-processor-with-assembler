from typing import Dict, List

class Helpers:
    @staticmethod
    def find_ci(data: str, to_search: str, pos: int = 0) -> bool:
        """
        Case-insensitive search function.

        Args:
        - data: The string to search within.
        - to_search: The substring to search for.
        - pos: Optional starting position for the search.

        Returns:
        - True if `to_search` is found in `data`, starting from `pos`.
        """
        data = data.lower()
        return to_search in data[pos:]

    @staticmethod
    def split(input_string: str, delimiter: str) -> List[str]:
        """
        Split a string into a list based on a delimiter.

        Args:
        - input_string: The string to split.
        - delimiter: The delimiter to use for splitting.

        Returns:
        - A list of substrings split from `input_string` based on `delimiter`.
        """
        return input_string.split(delimiter)

    @staticmethod
    def to_binary(num: int) -> str:
        """
        Convert an integer to a 6-bit binary string.

        Args:
        - num: The integer to convert (must be between 0 and 63).

        Returns:
        - A 6-bit binary string representation of `num`.
        """
        num = max(0, min(num, 63))
        return format(num, '06b')

# Opcodes and registers mappings
opcodes: Dict[str, str] = {
    "load": "00",
    "add": "01",
    "sub": "10",
    "jnz": "11"
}

registers: Dict[str, str] = {
    "r0": "00",
    "r1": "01",
    "r2": "10",
    "r3": "11"
}

class Assembler:
    def __init__(self, input_string: str):
        """
        Initialize the Assembler with an input assembly code string.

        Args:
        - input_string: The input assembly code as a string.
        """
        self.m_Input = input_string
        self.m_CurrentLabel = 1
        self.m_LabelAddress = {}

    def assemble(self) -> str:
        """
        Assemble the input assembly code into machine code.

        Returns:
        - The assembled machine code as a string.
        """
        self.calculate_label_addresses()
        m_Output = ""

        for line in self.m_Input.splitlines():
            line = line.replace(',', '')
            instruction = Helpers.split(line, ' ')
            opcode = instruction[0]

            if ':' in opcode:
                opcode = Helpers.split(opcode, ':')[1]

            m_Output += opcodes[opcode]
            m_Output += registers[instruction[1]]

            if Helpers.find_ci(opcode, "load"):
                m_Output += "00\n"
                m_Output += Helpers.to_binary(int(instruction[2]))
            elif Helpers.find_ci(opcode, "jnz"):
                m_Output += "00\n"
                m_Output += Helpers.to_binary(self.m_LabelAddress[instruction[2]])
            else:
                m_Output += registers[instruction[2]]

            m_Output += "\n"

        m_Output += "111111"  # End marker
        return m_Output

    def get_command_size(self, command: str) -> int:
        """
        Determine the size of a command in machine code.

        Args:
        - command: The assembly command string.

        Returns:
        - The size of the command in machine code (1 or 2).
        """
        if Helpers.find_ci(command, "load"):
            return 2
        else:
            return 1

    def calculate_label_addresses(self):
        """
        Calculate addresses for labels in the assembly code.
        """
        current_address = 0
        for line in self.m_Input.splitlines():
            if ':' in line:
                self.m_LabelAddress[Helpers.split(line, ':')[0]] = current_address
            current_address += self.get_command_size(line)

if __name__ == "__main__":
    input_file = 'input.txt'
    with open(input_file, 'r') as file:
        input_string = file.read()

    assembler = Assembler(input_string)
    print("output:\n" + assembler.assemble())
