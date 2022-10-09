module Controllers
  class CanvaController
    def self.tick(args); end

    def self.render(inputs, state, outputs, grid, args)
      add_grid(state, outputs)
      check_click(inputs, state)
    end

    # Sets the starting position, ending position, and color for the horizontal separator.
    # The starting and ending positions have the same y values.
    def self.horizontal_separator(y, x, x2)
      [x, y, x2, y, 150, 150, 150]
    end

    # Sets the starting position, ending position, and color for the vertical separator.
    # The starting and ending positions have the same x values.
    def self.vertical_separator(x, y, y2)
      [x, y, x, y2, 150, 150, 150]
    end

    # Outputs a border and a grid containing empty squares onto the screen.
    def self.add_grid(state, outputs)
      # Sets the x, y, height, and width of the grid.
      # There are 31 horizontal lines and 31 vertical lines in the grid.
      # Feel free to count them yourself before continuing!
      x = 640 - 500 / 2
      y = 640 - 500
      h = 500
      w = 500 # calculations done so the grid appears in screen's center
      lines_h = 31
      lines_v = 31

      # Sets values for the grid's border, grid lines, and filled squares.
      # The filled_squares variable is initially set to an empty array.
      state.grid_border ||= [x, y, h, w] # definition of grid's outer border
      state.grid_lines ||= draw_grid(x, y, h, w, lines_h, lines_v, state) # calls draw_grid method
      state.filled_squares ||= [] # there are no filled squares until the user fills them in

      # Outputs the grid lines, border, and filled squares onto the screen.
      outputs.lines.concat state.grid_lines
      outputs.borders << state.grid_border
      outputs.sprites << state.filled_squares
    end

    # Draws the grid by adding in vertical and horizontal separators.
    def self.draw_grid(x, y, h, w, lines_h, lines_v, state)
      # The grid starts off empty.
      grid = []

      # Calculates the placement and adds horizontal lines or separators into the grid.
      curr_y = y # start at the bottom of the box
      dist_y = h / (lines_h + 1) # finds distance to place horizontal lines evenly throughout 500 height of grid
      lines_h.times do
        curr_y += dist_y # increment curr_y by the distance between the horizontal lines
        grid << horizontal_separator(curr_y, x, x + w - 1) # add a separator into the grid
      end

      # Calculates the placement and adds vertical lines or separators into the grid.
      curr_x = x # now start at the left of the box
      dist_x = w / (lines_v + 1) # finds distance to place vertical lines evenly throughout 500 width of grid
      lines_v.times do
        curr_x += dist_x # increment curr_x by the distance between the vertical lines
        grid << vertical_separator(curr_x, y + 1, y + h) # add separator
      end

      # paint_grid uses a hash to assign values to keys.
      state.paint_grid ||= {
        'x' => x,
        'y' => y,
        'h' => h,
        'w' => w,
        'lines_h' => lines_h,
        'lines_v' => lines_v,
        'dist_x' => dist_x,
        'dist_y' => dist_y
      }

      grid
    end

    # Checks if the user is keeping the mouse pressed down and sets the mouse_hold variable accordingly using boolean values.
    # If the mouse is up, the user cannot drag the mouse.
    def self.check_click(inputs, state)
      if inputs.mouse.down # is mouse up or down?
        state.mouse_held = true # mouse is being held down
      elsif inputs.mouse.up # if mouse is up
        state.mouse_held = false # mouse is not being held down or dragged
        state.mouse_dragging = false
      end

      if state.mouse_held && # mouse needs to be down
         !inputs.mouse.click && # must not be first click
         (
          (
            inputs.mouse.previous_click.point.x - inputs.mouse.position.x # must not be first click
          ).abs > 15 # Need to move 15 pixels before "drag"
        )
        state.mouse_dragging = true
      end

      # If the user clicks their mouse inside the grid, the search_lines method is called with a click input type.
      if inputs.mouse.click && (inputs.mouse.click.point.inside_rect? state.grid_border)
        search_lines(state, inputs.mouse.click.point, :click)

      # If the user drags their mouse inside the grid, the search_lines method is called with a drag input type.
      elsif state.mouse_dragging && (inputs.mouse.position.inside_rect? state.grid_border)
        search_lines(state, inputs.mouse.position, :drag)
      end
    end

    # Sets the definition of a grid box and handles user input to fill in or clear grid boxes.
    def self.search_lines(state, point, input_type)
      point.x -= state.paint_grid['x'] # subtracts the value assigned to the "x" key in the paint_grid hash
      point.y -= state.paint_grid['y'] # subtracts the value assigned to the "y" key in the paint_grid hash

      # Remove code following the .floor and see what happens when you try to fill in grid squares
      point.x = (point.x / state.paint_grid['dist_x']).floor * state.paint_grid['dist_x']
      point.y = (point.y / state.paint_grid['dist_y']).floor * state.paint_grid['dist_y']

      point.x += state.paint_grid['x']
      point.y += state.paint_grid['y']

      # Sets definition of a grid box, meaning its x, y, width, and height.
      # Floor is called on the point.x and point.y variables.
      # Ceil method is called on values of the distance hash keys, setting the width and height of a box.
      grid_box = [
        point.x.floor,
        point.y.floor,
        state.paint_grid['dist_x'].ceil,
        state.paint_grid['dist_y'].ceil,
        'sprites/square/black.png'
      ]

      case input_type
      when :click # if user clicks their mouse
        if state.filled_squares.include? grid_box # if grid box is already filled in
          state.filled_squares.delete grid_box # box is cleared and removed from filled_squares
        else
          state.filled_squares << grid_box # otherwise, box is filled in and added to filled_squares
        end
      when :drag # if user drags mouse
        unless state.filled_squares.include? grid_box # unless the grid box dragged over is already filled in
          state.filled_squares << grid_box # the box is filled in and added to filled_squares
        end
      end
    end
  end
end
