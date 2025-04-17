from hello import printHello


def test_printHello():
    name = "Simo"
    assert "Hello" in printHello(name)
