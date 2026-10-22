return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.12.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 15,
  height = 10,
  tilewidth = 64,
  tileheight = 64,
  nextlayerid = 6,
  nextobjectid = 3,
  backgroundcolor = { 255, 255, 255 },
  properties = {},
  tilesets = {
    {
      name = "new-platformer-tileset",
      firstgid = 1,
      class = "",
      tilewidth = 64,
      tileheight = 64,
      spacing = 1,
      margin = 0,
      columns = 18,
      image = "assets/tilesets/spritesheet-tiles-default.png",
      imagewidth = 1169,
      imageheight = 1169,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 64,
        height = 64
      },
      properties = {},
      wangsets = {},
      tilecount = 324,
      tiles = {}
    },
    {
      name = "new-platformer-backgrounds",
      firstgid = 325,
      class = "",
      tilewidth = 256,
      tileheight = 256,
      spacing = 1,
      margin = 0,
      columns = 4,
      image = "assets/tilesets/spritesheet-backgrounds-default.png",
      imagewidth = 1027,
      imageheight = 1027,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 256,
        height = 256
      },
      properties = {},
      wangsets = {},
      tilecount = 16,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 15,
      height = 10,
      id = 2,
      name = "background",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        333, 0, 0, 0, 331, 0, 0, 0, 330, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        338, 0, 0, 0, 338, 0, 0, 0, 338, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 15,
      height = 10,
      id = 1,
      name = "foreground",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        175, 174, 174, 174, 174, 174, 174, 174, 174, 174, 174, 176, 0, 0, 0,
        172, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 173, 0, 0, 0,
        169, 168, 168, 168, 168, 168, 168, 168, 168, 168, 168, 170, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "items",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 64,
          y = 256,
          width = 64,
          height = 64,
          rotation = 0,
          opacity = 1,
          gid = 45,
          visible = true,
          properties = {
            ["spawn"] = true
          }
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 640,
          y = 256,
          width = 64,
          height = 64,
          rotation = 0,
          opacity = 1,
          gid = 37,
          visible = true,
          properties = {
            ["goal"] = true
          }
        }
      }
    }
  }
}
