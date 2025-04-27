// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title LotteryGame
 * @dev A simple number guessing game where players can win ETH prizes
 */
contract LotteryGame {
    struct Player {
        uint256 attempts;
        bool active;
    }

    // TODO: Declare state variables
    // - Mapping for player information
    // - Array to track player addresses
    // - Total prize pool
    // - Array for winners
    // - Array for previous winners

    mapping(address => Player) public players;
    address[] public playerAddresses;
    uint256 public totalPrize;
    address[] public winners;
    address[] public previousWinners;

    // TODO: Declare events
    // - PlayerRegistered
    // - GuessResult
    // - PrizesDistributed
    event PlayerRegistered(address indexed player, uint256 attempts);
    event GuessResult(address indexed player, uint256 guess, uint256 randomNumber, bool correct);
    event PrizesDistributed(address[] winners, uint256 prizeAmount);

    /**
     * @dev Register to play the game
     * Players must stake exactly 0.02 ETH to participate
     */
    function register() public payable {
        // TODO: Implement registration logic
        // - Verify correct payment amount
        // - Add player to mapping
        // - Add player address to array
        // - Update total prize
        // - Emit registration event
        require(msg.value == 0.02 ether, "Please stake 0.02 ETH");
        require(!players[msg.sender].active, "Player already registered");
        players[msg.sender] = Player(2,true);
        playerAddresses.push(msg.sender);
        totalPrize += msg.value;
        emit PlayerRegistered(msg.sender, 2);
    }

    /**
     * @dev Make a guess between 1 and 9
     * @param guess The player's guess
     */
    function guessNumber(uint256 guess) public {
        // TODO: Implement guessing logic
        // - Validate guess is between 1 and 9
        // - Check player is registered and has attempts left
        // - Generate "random" number
        // - Compare guess with random number
        // - Update player attempts
        // - Handle correct guesses
        // - Emit appropriate event
        require(guess >= 1 && guess <= 9, "Number must be between 1 and 9");
        require(players[msg.sender].active, "Player is not active");
        require(players[msg.sender].attempts > 0, "Player has already made 2 attempts");
        uint256 randomNumber = _generateRandomNumber();
        bool correct = (guess == randomNumber);

        if (correct) {
            winners.push(msg.sender);
            emit GuessResult(msg.sender, guess, randomNumber, correct);
        } else {
            players[msg.sender].attempts--;
            emit GuessResult(msg.sender, guess, randomNumber, correct);
        }
    }

    /**
     * @dev Distribute prizes to winners
     */
    function distributePrizes() public payable {
        // TODO: Implement prize distribution logic
        // - Calculate prize amount per winner
        // - Transfer prizes to winners
        // - Update previous winners list
        // - Reset game state
        // - Emit event
        require(winners.length > 0, "No winners to distribute prizes to");
        uint256 prizeAmountPerPlayer = totalPrize / winners.length;
        for (uint256 i = 0; i < winners.length; i++) {
            payable(winners[i]).transfer(prizeAmountPerPlayer);
        }
        previousWinners = winners;
        winners = new address[](0); // Reset winners
        totalPrize = 0; // Reset prize pool
        playerAddresses = new address[](0); // Reset player addresses
        emit PrizesDistributed(previousWinners, prizeAmountPerPlayer);

    }

    /**
     * @dev View function to get previous winners
     * @return Array of previous winner addresses
     */
    function getPrevWinners() public view returns (address[] memory) {
        // TODO: Return previous winners array
        return previousWinners;
    }

    /**
     * @dev Helper function to generate a "random" number
     * @return A uint between 1 and 9
     * NOTE: This is not secure for production use!
     */
    function _generateRandomNumber() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % 9 + 1;
    }
}
