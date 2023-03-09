export module file_writer;

import <fstream>;
import <optional>;
import <string>;

export std::optional<std::string> read_content() {
    std::ifstream stream{"/tmp/please"};

    if (not stream.is_open()) {
        return std::nullopt;
    }

    std::string firstLine{};

    std::getline(stream, firstLine);
    return firstLine;
}
