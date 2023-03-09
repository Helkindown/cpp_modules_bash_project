export module helloworld;
import <iostream>;

import file_writer;

export void hello() {
    std::cout << "Goodbye, Mars\n";

    if (auto value{read_content()}; value.has_value()) {
        std::cout << *value << '\n' << value->length() << '\n';
    } else {
        std::cout << "read_content failed !\n";
    }
}
