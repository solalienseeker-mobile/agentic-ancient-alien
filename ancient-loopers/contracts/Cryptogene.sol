// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Cryptogene {
    struct GeneticState {
        uint256 mutationRate;
        uint256 efficiency;
        uint256 adaptability;
        uint256 lastCheckpoint;
    }

    GeneticState public state;
    uint256 public constant EVOLUTION_INTERVAL = 180 days;

    event Evolved(uint256 mutationRate, uint256 efficiency, uint256 timestamp);

    constructor() {
        state = GeneticState(100, 100, 100, block.timestamp);
    }

    function evolve() external {
        require(block.timestamp >= state.lastCheckpoint + EVOLUTION_INTERVAL, "Too early");
        state.mutationRate += 5;
        state.efficiency = (state.efficiency * 101) / 100;
        state.adaptability += 10;
        state.lastCheckpoint = block.timestamp;
        emit Evolved(state.mutationRate, state.efficiency, block.timestamp);
    }

    function predictFutureState(uint256 year) external view returns (GeneticState memory) {
        uint256 periods = (year - 2024) * 2;
        return GeneticState(
            state.mutationRate + (periods * 5),
            state.efficiency * (101 ** periods) / (100 ** periods),
            state.adaptability + (periods * 10),
            state.lastCheckpoint
        );
    }
}
