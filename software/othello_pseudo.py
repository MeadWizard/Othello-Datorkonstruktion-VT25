import os

#defintion för de olika riktningarna för att vi ska kunna vända på brickor
Directions = [(0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1)]

#el boardddd

VR_WIDTH = 20   #Video ram bredd
BOARD_SIZE = 8
START_X = 6     #(20-8)//2 = 6
START_Y = 3     #(15-8) //2 = 3

# Gett alla brickor/positioner värden
BACKGROUND_TABLE = 0
EMPTY_BOX = 1
WHITE = 2
BLACK = 3

# initialiserar indexen x och y så vi kan starta spelet 
def board_index(x, y):
    return (START_Y + y) * VR_WIDTH + (START_X + x)

# Hur stort brädet är från början
video_ram = [BACKGROUND_TABLE] * (15 * 20)

# Hur stort brädet kommer vara på skärmen när vi kör spelet 
def init_board(vram):
    for y in range (8):
        for x in range (8):
            index = board_index(x, y)
            vram[index] = EMPTY_BOX

    # STARTPOSITIONER PÅ BRÄDET
    vram[board_index(3, 3)] = WHITE
    vram[board_index(4, 4)] = WHITE
    vram[board_index(3, 4)] = BLACK
    vram[board_index(4, 3)] = BLACK

def draw_cursor(vram, cursor_x, cursor_y):
    index = board_index(cursor_x, cursor_y)

    if vram[index] % 10 in (EMPTY_BOX, WHITE, BLACK):
        vram[index] += 10

def print_board(vram, cursor_x, cursor_y):
    os.system('cls' if os.name == 'nt' else 'clear')
    symbols = {
        BACKGROUND_TABLE: " ",
        EMPTY_BOX: ".",
        WHITE: "W",
        BLACK: "B"
    }

    print (" " + " ".join(str(x) for x in range(BOARD_SIZE)))
    for y in range (BOARD_SIZE):
        row = f"{y} "
        for x in range (BOARD_SIZE):
            index = board_index(x, y)
            base = vram[index] % 10
            char = symbols[base]
            if x == cursor_x and y == cursor_y:
                char = f"[{char}]"
            row += char + " "
        print(row)
    print()

def place_piece(vram, x, y, color):
    index = board_index(x, y)
    if vram[index] % 10 != EMPTY_BOX:
        return False 
    
    opponent = WHITE if color == BLACK else BLACK
    flip_it = []

    for dx, dy in Directions:
        nx, ny = x + dx, y + dy
        seq = []

        while 0 <= nx < BOARD_SIZE and 0 <= ny < BOARD_SIZE:
            nidx = board_index(nx, ny)
            cell = vram[nidx] % 10
            if cell == opponent:
                seq.append((nx, ny))
            else:
                break
            nx += dx
            ny += dy

        if 0 <= nx < BOARD_SIZE and 0 <= ny < BOARD_SIZE:
            nidx = board_index(nx, ny)
            if vram[nidx] % 10 == color and seq:
                flip_it.extend(seq)


    if not flip_it:
        return False
    
    vram[index] = color

    for fx, fy in flip_it:
        fidx = board_index(fx, fy)
        vram[fidx] = color

    return True

def has_valid_move(vram, color):
    opponent = WHITE if color == BLACK else BLACK
    for y in range(BOARD_SIZE):
        for x in range(BOARD_SIZE):
            index = board_index(x, y)
            if vram[index] % 10 != EMPTY_BOX:
                continue

            for dx, dy in Directions:
                nx, ny = x + dx, y + dy
                found_opponent = False

                while 0 <= nx < BOARD_SIZE and 0 <= ny < BOARD_SIZE:
                    cell = video_ram[board_index(nx, ny)] % 10
                    if cell == opponent:
                        found_opponent = True
                    elif cell == color and found_opponent:
                        return True
                    else:
                        break
                    nx += dx
                    ny += dy
    return False

def score(vram):
    vit = svart = 0
    for y in range(BOARD_SIZE):
        for x in range(BOARD_SIZE):
            value = vram[board_index(x, y)] % 10
            if value == WHITE: vit +=1
            if value == BLACK: svart += 1
    return vit, svart

def play_game():
    video_ram = [BACKGROUND_TABLE] * (15 * VR_WIDTH)
    init_board(video_ram)
    cursor_x, cursor_y = 0, 0
    current_player = BLACK

    while True:
        for y in range(BOARD_SIZE):
            for x in range(BOARD_SIZE):
                index = board_index(x, y)
                if video_ram[index] >= 10:
                    video_ram[index] -= 10
    
        if not has_valid_move(video_ram, BLACK) and not has_valid_move(video_ram, WHITE):
            w_score, b_score = score(video_ram)
            print_board(video_ram, -1, -1)
            white_score, black_score = score(video_ram)
            print_board(video_ram, -1, -1)
            print(f"GAME OVER! Points: Black {black_score} - White {white_score}")
            if black_score > white_score:
                print("BLACK IS WINNER")
            elif white_score > black_score:
                print("WHITE IS WINNER")
            else:
                print("IT'S A TIE")
            break

        if not has_valid_move(video_ram, current_player):
            name = "Black" if current_player == BLACK else "White"
            print_board(video_ram, cursor_x, cursor_y)
            print(f"{name} has no valid moves, next persons turn...")
            input("Press enter to continue")
            current_player = WHITE if current_player == BLACK else BLACK
            continue







    init_board(video_ram)
    cursor_x = 0
    cursor_y = 0
    current_player = BLACK
    draw_cursor(video_ram, cursor_x, cursor_y)
    print_board(video_ram, cursor_x, cursor_y)

    print("\nWASD = flytta | SPACE = placera | Q = avsluta")
    key = input(">> ").lower()

    if key == "q":
        return False  
    elif key == "w" and cursor_y > 0:
        cursor_y -= 1
    elif key == "s" and cursor_y < 7:
        cursor_y += 1
    elif key == "a" and cursor_x > 0:
        cursor_x -= 1
    elif key == "d" and cursor_x < 7:
        cursor_x += 1
    elif key == " ":
        if place_piece(video_ram, cursor_x, cursor_y, current_player):
            current_player = WHITE if current_player == BLACK else BLACK 

if __name__ == "__main__":
    while True:
        again = play_game()
        if not again:
            break
        answer = input("Do you want to play again? (j/n): ").strip().lower()
        if answer != "j":
            print("Thank you for a good game wallahiiii! Bye Bye")
            break 