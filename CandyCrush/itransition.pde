interface ITransition{
    void update(float dt);
    void draw();
    void init();
    boolean isStarted();
}
