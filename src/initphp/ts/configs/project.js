const PROJECT = {
    production: true,
    conf: 'configs',
    copy: {
        initphp: {
            config: {
                from: './configs/src/initphp/',
                to: '../configs/',
            },
            build: {
                from: './src/initphp/ts/configs/project.js',
                to: '../configs/',
            },
            logos: {
                from: './extra/initphp/logos',
                to: 'logos/',
            },
            root: {
                from: './assets/initphp/copy/root',
                to: '',
            },
            php: {
                from: './src/initphp/php/',
                to: '..',
            },
        },
    },
};

export default PROJECT;
