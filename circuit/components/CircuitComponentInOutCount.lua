    local ComponentTypeToInOutCount = {
        AND = {2, 1},
        OR = {2, 1},
        NOT = {1, 1},
        XOR = {2, 1},
        NAND = {2, 1},
        NOR = {2, 1},
        XNOR = {2, 1},
        REGISTER = {2, 1},
        INPUT = {0, 1},
        OUTPUT = {1, 0},
        DELAY = {1, 1},
        HALF_ADD = {2, 2},
        FULL_ADD = {3, 2}
    }

    return ComponentTypeToInOutCount